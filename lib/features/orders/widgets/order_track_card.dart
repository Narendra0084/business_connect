import 'package:bihar_business_connect/features/listings/domain/model/order_management_model.dart';
import 'package:bihar_business_connect/features/orders/domain/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderTrackCard extends StatelessWidget {
  const OrderTrackCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy');

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.productName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${order.quantity} ${order.unit} | '
              'Rs ${order.finalPrice.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 8),
            Text('Delivery: ${order.deliveryType.label}'),
            Text(
              'Committed date: '
              '${formatter.format(order.deliveryDate)}',
            ),
            if (order.pickupLocation != null)
              Text('Pickup: ${order.pickupLocation}'),
            if (order.dropLocation != null) Text('Drop: ${order.dropLocation}'),
            const SizedBox(height: 24),
            ShipmentStepper(
              status: order.status,
            ),
            const SizedBox(height: 20),
            ShipmentAction(
              order: order,
            ),
          ],
        ),
      ),
    );
  }
}

class ShipmentStepper extends StatelessWidget {
  const ShipmentStepper({
    super.key,
    required this.status,
  });

  final OrderStatus status;

  static const steps = [
    OrderStatus.confirmed,
    OrderStatus.preparingShipment,
    OrderStatus.shipped,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = steps.indexOf(status);

    return Column(
      children: [
        Row(
          children: List.generate(
            steps.length,
            (index) {
              final isCompleted = index < currentIndex;
              final isCurrent = index == currentIndex;

              return Expanded(
                child: Row(
                  children: [
                    _StepCircle(
                      isCompleted: isCompleted,
                      isCurrent: isCurrent,
                      status: steps[index],
                    ),
                    if (index != steps.length - 1)
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          color: index < currentIndex
                              ? Colors.green
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: steps.map((step) {
            return Expanded(
              child: Text(
                _statusLabel(step),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  static String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return 'Confirmed';

      case OrderStatus.preparingShipment:
        return 'Preparing';

      case OrderStatus.shipped:
        return 'Shipped';

      case OrderStatus.delivered:
        return 'Delivered';

      default:
        return status.name;
    }
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.isCompleted,
    required this.isCurrent,
    required this.status,
  });

  final bool isCompleted;
  final bool isCurrent;
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: isCurrent ? 38 : 32,
      height: isCurrent ? 38 : 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isCurrent
            ? Colors.green
            : Colors.grey.shade300,
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.25),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Icon(
        isCompleted
            ? Icons.check
            : _icon(status),
        size: 18,
        color: isCompleted || isCurrent
            ? Colors.white
            : Colors.grey.shade600,
      ),
    );
  }

  IconData _icon(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;

      case OrderStatus.preparingShipment:
        return Icons.inventory_2_outlined;

      case OrderStatus.shipped:
        return Icons.local_shipping_outlined;

      case OrderStatus.delivered:
        return Icons.home_outlined;

      default:
        return Icons.circle_outlined;
    }
  }
}
class ShipmentAction extends StatelessWidget {
  const ShipmentAction({super.key, 
    required this.order,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    switch (order.status) {
      case OrderStatus.confirmed:
        return _actionButton(
          context,
          label: 'Start Preparing Shipment',
          icon: Icons.inventory_2_outlined,
          nextStatus: OrderStatus.preparingShipment,
        );

      case OrderStatus.preparingShipment:
        return _actionButton(
          context,
          label: 'Mark as Shipped',
          icon: Icons.local_shipping_outlined,
          nextStatus: OrderStatus.shipped,
        );

      case OrderStatus.shipped:
        return _actionButton(
          context,
          label: 'Mark as Delivered',
          icon: Icons.check_circle_outline,
          nextStatus: OrderStatus.delivered,
        );

      case OrderStatus.delivered:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              SizedBox(width: 8),
              Text(
                'Order Delivered',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _actionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required OrderStatus nextStatus,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // context.read<OrdersCubit>().updateStatus(
          //       orderId: order.id,
          //       status: nextStatus,
          //     );
        },
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
